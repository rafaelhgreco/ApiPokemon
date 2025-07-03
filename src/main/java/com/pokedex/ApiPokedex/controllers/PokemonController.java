package com.pokedex.ApiPokedex.controllers;

import com.pokedex.ApiPokedex.dto.PokemonCreateDTO;
import com.pokedex.ApiPokedex.entity.PokemonEntity;
import com.pokedex.ApiPokedex.services.PokemonService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pokemons")
public class PokemonController {

    @Autowired
    private PokemonService pokemonService;

    @PostMapping
    public ResponseEntity<PokemonEntity> createPokemon(@Valid @RequestBody PokemonCreateDTO pokemonCreateDTO) {
        PokemonEntity createdPokemon = pokemonService.createPokemon(pokemonCreateDTO);
        return new ResponseEntity<>(createdPokemon, HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<List<PokemonEntity>> getAllPokemons() {
        List<PokemonEntity> pokemons = pokemonService.getAllPokemons();
        return ResponseEntity.ok(pokemons);
    }
}