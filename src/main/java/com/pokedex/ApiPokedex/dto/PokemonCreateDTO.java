package com.pokedex.ApiPokedex.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class PokemonCreateDTO {
    @NotBlank
    private String name;
    @NotBlank
    private String type;
    @NotBlank
    private String image;
}