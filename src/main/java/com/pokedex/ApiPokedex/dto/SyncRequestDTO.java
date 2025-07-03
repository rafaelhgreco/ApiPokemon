package com.pokedex.ApiPokedex.dto;

import lombok.Data;
import java.util.List;

// DTO que agrupa as listas de usuários e pokémons para a requisição de sync
@Data
public class SyncRequestDTO {
    private List<UserSyncDTO> users;
    private List<PokemonSyncDTO> pokemons;
}