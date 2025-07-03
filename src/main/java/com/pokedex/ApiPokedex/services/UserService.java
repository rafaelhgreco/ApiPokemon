package com.pokedex.ApiPokedex.services;

import com.pokedex.ApiPokedex.dto.UserCreateDTO;
import com.pokedex.ApiPokedex.entity.UserEntity;
import com.pokedex.ApiPokedex.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public UserEntity createUser(UserCreateDTO userCreateDTO) {
        UserEntity newUser = UserEntity.builder()
                .email(userCreateDTO.getEmail())
                .password(userCreateDTO.getPassword()) // Em um caso real, seria a senha com hash
                .build();

        return userRepository.save(newUser);
    }
}