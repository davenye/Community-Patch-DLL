#include "CvGameCoreDLLPCH.h"
#include "DealLogger.h"


void logdealoth(const char * msg, const CvDeal* const_deal, PlayerTypes me, PlayerTypes other)
{
	// people were real lazy with their usage of const :(
	CvDeal* deal = const_cast<CvDeal*>(const_deal);
	FILogFile * pLog = LOGFILEMGR.GetLog("Deals.log", FILogFile::kDontTimeStamp);
	if (pLog)
	{
		pLog->Msg("Turn %d: %s\n", GC.getGame().getGameTurn(), msg);

		if (deal)
		{
			pLog->Msg("Deal %d -> %d", deal->GetFromPlayer(), deal->GetToPlayer());
			
			if (me != deal->GetFromPlayer() || me != deal->GetToPlayer())
				pLog->Msg("(Me neither from nor to: %d\n", me);
			if (other != deal->GetOtherPlayer(me))
				pLog->Msg("(Other not the other: %d\n", other);

			pLog->Msg("Valid=%d, Items=%d, Start=%d, Duration=%d, ConsiderRenew=%d, CheckedRenew=%d", deal->AreAllTradeItemsValid(), deal->GetNumItems(), deal->GetStartTurn(), deal->GetDuration(), deal->m_bConsideringForRenewal, deal->m_bCheckedForRenewal);
			for (TradedItemList::const_iterator it = deal->m_TradedItems.begin_const(); it != deal->m_TradedItems.end_const(); it++)
			{
				//pLog->Msg("+Item value=", it->m_iValue);
			}
		}
		else {
			pLog->Msg("Deal NULL!!!?");
		}

	}
}

void logdealmsg(const char * msg, PlayerTypes from, PlayerTypes to)
{
	logdeal(msg, NULL, from, to);
}

void logdeal(const char * msg, const CvDeal* const_deal, PlayerTypes from, PlayerTypes to)
{
	// people were real lazy with their usage of const :(
	CvDeal* deal = const_cast<CvDeal*>(const_deal);
	FILogFile * pLog = LOGFILEMGR.GetLog("Deals.log", FILogFile::kDontTimeStamp);
	if (pLog)
	{
		pLog->Msg("Turn %d: %s\n", GC.getGame().getGameTurn(), msg);
		
		if (deal)
		{
			pLog->Msg("Deal %d -> %d", deal->GetFromPlayer(), deal->GetToPlayer());

			if (from != 99 && deal->GetFromPlayer() != from)
				pLog->Msg("(From %d != %d)\n", deal->GetFromPlayer(), from);
			if (to != 99 && deal->GetToPlayer() != to)
				pLog->Msg("(To %d != %d)\n", deal->GetToPlayer(), to);

			pLog->Msg("Valid=%d, Items=%d, Start=%d, Duration=%d, ConsiderRenew=%d, CheckedRenew=%d", deal->AreAllTradeItemsValid(), deal->GetNumItems(), deal->GetStartTurn(), deal->GetDuration(), deal->m_bConsideringForRenewal, deal->m_bCheckedForRenewal);
			for (TradedItemList::const_iterator it = deal->m_TradedItems.begin_const(); it != deal->m_TradedItems.end_const(); it++)
			{
				//pLog->Msg("+Item value=", it->m_iValue);
			}
		}
		else {
			if(from != -99 || to != -99)
				pLog->Msg("Deal? %d -> %d", from, to);
		}
		
	}
}