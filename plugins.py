#!/usr/bin/env python3
import requests
from urllib.parse import urljoin
import time
import re
from bs4 import BeautifulSoup

# Set the URL you want to webscrape from
START_URL = 'https://caddyserver.com/docs/docker'
BASE_URL = 'https://caddyserver.com/'


def scrape_plugin_anchors(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")

    # Find keyword to start scrapping the plugin URL
    start_dom = soup.find('h3', text='Plugins')
    return start_dom.find_all_next('a', href=re.compile('/docs/.+'))


def scrape_repo_url(plugin_url):
    response = requests.get(plugin_url)
    soup = BeautifulSoup(response.text, "html.parser")
    return soup.find('b', text='Plugin Website').find_next('a').attrs['href']


def generate_mapping(base_url):
    def generate_plugin_page_url(url):
        return urljoin(base_url, url)

    def generate_mapping_helper(anchor):
        label = anchor.text
        url = anchor.attrs['href']
        
        # Form the page URL first
        plugin_url = generate_plugin_page_url(url)

        # Scrape the actual repo URL
        repo_url = scrape_repo_url(plugin_url)
        return [label, repo_url]

    return generate_mapping_helper


def main():
    anchors = scrape_plugin_anchors(START_URL)
    plugins = map(generate_mapping(BASE_URL), anchors)

    for p in plugins:
        print(p)


if __name__ == "__main__":
    main()
