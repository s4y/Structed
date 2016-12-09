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
 * {
 *  Dictionary: {
 *    validate: (member) => member instanceof DictionaryEntry
 *  }
 *  DictionaryEntry: {
 *    validate: (member) => member.length == 2 && member[0] instanceof String
 *  }
 * }
 *
 */

const doc = new Document(data);
console.log(doc);
