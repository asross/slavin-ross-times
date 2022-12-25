import pytesseract
import glob

for img in glob.glob('ocr/*.png'):
    if os.path.exists(img.replace('png', 'txt')):
        continue
    with open(img.replace('png', 'txt'), 'w') as txt:
        string = pytesseract.image_to_string(img)
        print(string)
        txt.write(string)
