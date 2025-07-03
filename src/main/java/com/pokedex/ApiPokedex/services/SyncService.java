package com.pokedex.ApiPokedex.services;

import com.pokedex.ApiPokedex.dto.SyncRequestDTO;
import com.pokedex.ApiPokedex.entity.PokemonEntity;
import com.pokedex.ApiPokedex.entity.UserEntity;
import com.pokedex.ApiPokedex.repository.PokemonRepository;
import com.pokedex.ApiPokedex.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class SyncService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PokemonRepository pokemonRepository;

    @Transactional
    public void performSync(SyncRequestDTO syncData) {
        if (syncData.getUsers() != null && !syncData.getUsers().isEmpty()) {
            List<UserEntity> userEntities = syncData.getUsers().stream()
                    .map(dto -> UserEntity.builder()
                            .id(dto.getId())
                            .email(dto.getEmail())
                            .password(dto.getPassword())
                            .build())
                    .collect(Collectors.toList());

            userRepository.saveAll(userEntities);
            log.info("Sincronizados {} usuários.", userEntities.size());
        }

        if (syncData.getPokemons() != null && !syncData.getPokemons().isEmpty()) {
            List<PokemonEntity> pokemonEntities = syncData.getPokemons().stream()
                    .map(dto -> PokemonEntity.builder()
                            .id(dto.getId())
                            .name(dto.getName())
                            .type(dto.getType())
                            .image(dto.getImage())
                            .build())
                    .collect(Collectors.toList());

            pokemonRepository.saveAll(pokemonEntities);
            log.info("Sincronizados {} pokémons.", pokemonEntities.size());
        }
    }
}