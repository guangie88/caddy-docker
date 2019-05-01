#!/usr/bin/env python3
from bs4 import BeautifulSoup
import re
import requests
from urllib.parse import urljoin
import yaml
import sys

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
    href = soup.find('b', text='Plugin Website').find_next('a').attrs['href']
    return re.compile('^http://').sub('', re.compile('^https://').sub('', href))


def generate_plugin_pairs(base_url):
    def generate_plugin_page_url(url):
        return urljoin(base_url, url)

    def generate_mapping_helper(anchor):
        # Convert dot to dash because it is difficult to work with dot for keys
        label = anchor.text.replace('.', '-')
        url = anchor.attrs['href']

        print('Processing {}...'.format(label), file=sys.stderr)
        
        # Form the page URL first
        plugin_url = generate_plugin_page_url(url)

        # Scrape the actual repo URL
        repo_url = scrape_repo_url(plugin_url)
        return [label, repo_url]

    return generate_mapping_helper


def generate_plugin_map(pairs):
    return dict(pairs)


def main():
    anchors = scrape_plugin_anchors(START_URL)
    plugins = map(generate_plugin_pairs(BASE_URL), anchors)
    plugin_map = generate_plugin_map(plugins)

    print(yaml.dump(dict(plugins=plugin_map)))


if __name__ == "__main__":
    main()
