package com.pokedex.ApiPokedex.dto;

import lombok.Data;

// DTO para receber dados de pokemon na sincronização
@Data
public class PokemonSyncDTO {
    private Long id;
    private String name;
    private String type;
    private String image;
}