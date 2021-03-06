import re
from unidecode import unidecode

import requests
from flask import Flask, request, abort, redirect

app = Flask(__name__)

_punct_re = re.compile(r'[\t !"#$%&\'()*\-/<=>?@\[\\\]^_`{|},.]+')

def slugify(text, delim=u'-'):
    """Generates an ASCII-only slug."""
    result = []
    for word in _punct_re.split(text.lower()):
        result.extend(unidecode(word).split())
    return unicode(delim.join(result))

def clean_postcode(postcode):
  return re.sub('[^A-Z0-9]', '', postcode.upper())

@app.route("/postcode/", methods=['GET', ])
def postcode():
    ERROR_URL = "/postcode-error/"
    postcode = request.args.get('postcode', None)
    if not postcode:
        return redirect(ERROR_URL, code=302)

    postcode = clean_postcode(postcode)
    url = "http://mapit.mysociety.org/postcode/{}".format(postcode[:8])
    resp = requests.get(url)
    # Invalid postcode
    if resp.status_code != 200:
        return redirect(ERROR_URL, code=302)
    data = resp.json()
    WMC = str(data['shortcuts']['WMC'])
    slug = slugify(data['areas'][WMC]['name'])
    URL = "/constituency/{0}/{1}".format(
        WMC, slug
    )

    return redirect(URL, code=302)

if __name__ == "__main__":
    app.run(debug=True)