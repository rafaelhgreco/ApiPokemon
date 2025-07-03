package com.pokedex.ApiPokedex.controllers;

import com.pokedex.ApiPokedex.dto.SyncRequestDTO;
import com.pokedex.ApiPokedex.services.SyncService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SyncController {

    @Autowired
    private SyncService syncService;

    @PostMapping("/sync")
    public ResponseEntity<String> synchronizeData(@RequestBody SyncRequestDTO syncRequest) {

        syncService.performSync(syncRequest);
        return ResponseEntity.ok("Sincronização concluída com sucesso.");
    }
}