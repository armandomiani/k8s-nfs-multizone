import os

from flask import Flask, jsonify


app = Flask(__name__)


@app.route('/')
def home():
    return jsonify(data={
        'files': __get_files()
    })


@app.route('/write/<filename>')
def write(filename):
    with open('data/{}.txt'.format(filename), 'w+') as f:
        f.write('OK')
        f.close()
    return jsonify(data={'success': True})


def __get_files():
    files = []
    for r, d, f in os.walk('data/'):
        for file in f:
            if '.txt' in file:
                files.append(os.path.join(r, file))
    return files


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
