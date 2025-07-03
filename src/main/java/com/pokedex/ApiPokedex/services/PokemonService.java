package com.pokedex.ApiPokedex.services;

import com.pokedex.ApiPokedex.dto.PokemonCreateDTO;
import com.pokedex.ApiPokedex.entity.PokemonEntity;
import com.pokedex.ApiPokedex.repository.PokemonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PokemonService {

    @Autowired
    private PokemonRepository pokemonRepository;

    public PokemonEntity createPokemon(PokemonCreateDTO pokemonCreateDTO) {
        PokemonEntity newPokemon = PokemonEntity.builder()
                .name(pokemonCreateDTO.getName())
                .type(pokemonCreateDTO.getType())
                .image(pokemonCreateDTO.getImage())
                .build();
        return pokemonRepository.save(newPokemon);
    }

    public List<PokemonEntity> getAllPokemons() {
        return pokemonRepository.findAll();
    }
}