#pragma once
#include "CvDealClasses.h"

void logdealoth(const char * msg, const CvDeal* deal, PlayerTypes me, PlayerTypes other);
void logdealmsg(const char * msg, PlayerTypes from = (PlayerTypes)-99, PlayerTypes to = (PlayerTypes)-99);
void logdeal(const char * msg, const CvDeal* deal = NULL, PlayerTypes from = (PlayerTypes) -99, PlayerTypes to = (PlayerTypes) -99);

