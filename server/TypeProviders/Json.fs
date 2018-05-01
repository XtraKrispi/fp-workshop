module Json 

open System
open FSharp.Data

type Game = {
  name: string
  yearPublished: int
  lastModifiedDate: DateTime
}

type MyJson = JsonProvider<"""
{
  "name": "Super Smash Bros.",
  "yearPublished": 2001,
  "lastModifiedDate": "2001-02-02"
}
""">

let getGame str =
  let json = MyJson.Parse(str)
  {
    name = json.Name
    yearPublished = json.YearPublished
    lastModifiedDate = json.LastModifiedDate
  }

type RickAndMortyCharacterJson = JsonProvider<"https://rickandmortyapi.com/api/character/">

type Character = {
  name: string
  gender: string
  species: string
}

let getCharacters () =
  let json = RickAndMortyCharacterJson.Load("https://rickandmortyapi.com/api/character/")
  json.Results
  |> Array.map (fun j -> { name = j.Name; gender = j.Gender; species = j.Species})