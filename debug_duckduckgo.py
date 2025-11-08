"""Debug script to see what DuckDuckGo actually returns"""
import requests
from bs4 import BeautifulSoup

session = requests.Session()
session.headers.update({
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
})

query = "Stanford University US official website"
search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

print(f"Searching: {query}")
print(f"URL: {search_url}\n")

response = session.get(search_url, timeout=10)
print(f"Status code: {response.status_code}\n")

soup = BeautifulSoup(response.text, 'html.parser')

# Check what classes are available
print("Looking for result links...")
result_links = soup.find_all('a', class_='result__a')
print(f"Found {len(result_links)} links with class 'result__a'\n")

if result_links:
    for i, link in enumerate(result_links[:3], 1):
        print(f"Link {i}:")
        print(f"  Text: {link.get_text()[:100]}")
        print(f"  Href: {link.get('href', 'NO HREF')[:200]}")
        print()
else:
    # Try other classes
    print("Trying other link classes...")
    all_links = soup.find_all('a', href=True)
    print(f"Total links found: {len(all_links)}\n")

    # Show first few links
    for i, link in enumerate(all_links[:10], 1):
        classes = link.get('class', [])
        href = link.get('href', '')
        text = link.get_text()[:50]
        print(f"Link {i}: class={classes}, href={href[:100]}, text={text}")
