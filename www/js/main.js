'use strict';

const data = {
    "id": 1,
    "name": "A green door",
    "price": 12.50,
    "tags": ["home", "green"]
};

/*
 *
 * (Dictionary [
 *   (DictionaryEntry [(String ["id"]) (Number [1])])
 *   (DictionaryEntry [(String ["name"]) (String ["A green door"])])
 *   (DictionaryEntry [(String ["price"]) (Number [12.50])])
 *   (DictionaryEntry [(String ["tags"]) (Array [
 *     (String ["home"])
 *     (String ["green"])
 *   ])])
 * ])
 *
 * 
 *
 */

const doc = new Document(data);
console.log(doc);
