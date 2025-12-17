#!/usr/bin/env python
# coding: utf-8

import string
import re
import os
import nltk
from nltk.corpus import stopwords
from nltk import word_tokenize
from wordcloud import WordCloud
import matplotlib.pyplot as plt

nltk.download('punkt', quiet=True)
nltk.download('stopwords', quiet=True)

dir_source = "/home/annasugak/Bureau/projet/PPE-projet/dumps-txt/dumps-txt-russe"
path_resultat = "/home/annasugak/Bureau/projet/PPE-projet/tableaux/nuage_mots_russe.png"

punctuations = re.compile("[" + re.escape(string.punctuation) + "«»…" + "]+")
target_word = r"[Сс]вет\w*"

russian_stopwords = stopwords.words("russian")
russian_stopwords.extend([
    'света', 'свету', 'светом', 'свете', 'светы', 'светов', 'светам', 'светах', 'светам',
    'это', 'который', 'года', 'было', 'есть', 'свои', 'вас', 'вам', 'эта', 'эти', 'наш', 'для', 'что'
])

all_contexts = []

for filename in os.listdir(dir_source):
    if filename.endswith(".txt"):
        filepath = os.path.join(dir_source, filename)
        with open(filepath, "r", encoding="utf-8", errors='ignore') as f:
            content = f.read().lower()
            content = punctuations.sub('', content)
            found = re.findall(r"((?:\S+\s+){0,15}" + target_word + r"(?:\s+\S+){0,15})", content)
            all_contexts.extend(found)

if all_contexts:
    final_text = " ".join(all_contexts)
    tokens = word_tokenize(final_text)
    filtered_tokens = [t for t in tokens if t not in russian_stopwords and len(t) > 2]

    text_for_cloud = " ".join(filtered_tokens)

    wordcloud = WordCloud(
        width=1200, 
        height=800, 
        background_color='white',
        colormap='plasma',
        max_words=150,
        max_font_size=200, 
        prefer_horizontal=0.7
    ).generate(text_for_cloud)

    wordcloud.to_file(path_resultat)

    plt.figure(figsize=(15, 10))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis("off")
    plt.show()
