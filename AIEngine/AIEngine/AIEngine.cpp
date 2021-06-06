//
//  engine.cpp
//  Xiang
//
//  Created by Horace Ho on 2012/10/29.
//  Copyright (c) 2012 Horace Ho. All rights reserved.
//
#include <stdio.h>
#include "hash.h"
#include "search.h"
#include "AIEngine.h"

const int INTERRUPT_COUNT = 4096; // 搜索若干结点后调用中断

void engineInit(const char *bookPath)
{
    strncpy(Search.szBookFile, bookPath, 1024);
    PreGenInit();
    NewHash(24); // 24=16MB, 25=32MB, 26=64MB, ...
    
    Search.pos.FromFen(cszStartFen);
    Search.pos.nDistance = 0;
    Search.pos.PreEvaluate();
    Search.nBanMoves = 0;
    Search.bQuit = Search.bBatch = Search.bDebug = false;
    Search.bUseHash = Search.bUseBook = Search.bNullMove = Search.bKnowledge = true;
    Search.bIdle = false;
    Search.nCountMask = INTERRUPT_COUNT - 1;
    Search.nRandomMask = 0;
    Search.rc4Random.InitRand();
}

void engineQuit()
{
    DelHash();
}

void engineSetFEN(const char *fen)
{
    Search.pos.FromFen(fen);
    Search.pos.nDistance = 0;
    Search.pos.PreEvaluate();
    Search.nBanMoves = 0;
}

const char engineGetPieceAt(int file, int rank)
{
    const unsigned char *squares = Search.pos.ucpcSquares;
    char piece = ' ';
    int square = squares[COORD_XY(file, rank)];
    if (square != 0) {
        piece = PIECE_BYTE(PIECE_TYPE(square)) + (square < 32 ? 0 : 'a' - 'A');
    }
    return piece;
}

uint32_t engineThink(const int seconds)
{
    Search.nGoMode = GO_MODE_TIMER;
    Search.nProperTimer = seconds * 1000;
    Search.nMaxTimer = seconds * 1000 / 2;
    uint32_t bestMove = SearchMain(UCCI_MAX_DEPTH);
    return bestMove;
}

bool doEngineMove(uint32_t eleeyeMove) {
    int move = COORD_MOVE(eleeyeMove);
    return Search.pos.MakeMove(move);
}

bool isLegalMove(uint32_t eleeyeMove) {
    int move = COORD_MOVE(eleeyeMove);
    return Search.pos.LegalMove(move);
}
bool isMate() {
    return Search.pos.IsMate();
}

bool isInCheck() {
    return Search.pos.LastMove().ChkChs > 0;
}

bool isDraw() {
   return (Search.pos.IsDraw() || Search.pos.RepStatus(3) > 0);
}
