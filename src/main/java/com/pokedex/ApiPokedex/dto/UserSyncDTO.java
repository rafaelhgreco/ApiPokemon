package com.pokedex.ApiPokedex.dto;

import lombok.Data;

// DTO para receber dados de usuário na sincronização
@Data
public class UserSyncDTO {
    private Long id;
    private String email;
    private String password;
}