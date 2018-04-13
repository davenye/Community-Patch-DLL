#include "CvGameCoreDLLPCH.h"
#include "CvDealMaker.h"



#include "CvDealClasses.h"
#include "CvDealAI.h"
#include "CvDiplomacyAI.h"


CvDealMaker::CvDealMaker()
{
}


CvDealMaker::~CvDealMaker()
{
}


struct DealModArgs
{
	CvDealAI& obj;
	//CvDeal* pDeal;
	PlayerTypes eThem;
	bool bDontChangeTheirExistingItems;
	bool bDontChangeMyExistingItems;
	int iTotalValue;
	int iValueImOffering;
	int iValueTheyreOffering;
	int iAmountOverWeWillRequest;
	bool bUseEvenValue;

	int iDealDuration;

};

struct DealModResult
{
	CvDeal deal;

	int iValue;
	int iValueToMe;
	int iValueToThem;

	bool bCantMatchOffer;

	bool bAcceptable;

};

// oh yeah not modern C++ :(
struct DealModBase
{
	virtual ~DealModBase() {}

	virtual void modify(CvDeal* deal, DealModArgs& args) = 0;
};


struct DealMod1 : DealModBase
{
	typedef void (CvDealAI::*Func)(CvDeal*, PlayerTypes, bool, int&, int&, int&, int, bool);
	Func func;
	bool us;
	DealMod1(Func func, bool us) : func(func), us(us) {}
	virtual void modify(CvDeal* deal, DealModArgs& args)
	{
		(args.obj.*func)(deal, args.eThem, us ? args.bDontChangeMyExistingItems : args.bDontChangeTheirExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iAmountOverWeWillRequest, args.bUseEvenValue);
	}
};

struct DealMod2 : DealModBase
{	
	typedef void (CvDealAI::*Func)(CvDeal*, PlayerTypes, bool, int&, int&, int&, int, int, bool);
	Func func;
	bool us;
	DealMod2(Func func, bool us) : func(func), us(us) {}
	virtual void modify(CvDeal* deal, DealModArgs& args)
	{
		(args.obj.*func)(deal, args.eThem, us ? args.bDontChangeMyExistingItems : args.bDontChangeTheirExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iAmountOverWeWillRequest, args.iDealDuration, args.bUseEvenValue);
	}
};

struct DealMod3 : DealModBase
{
	typedef void (CvDealAI::*Func)(CvDeal*, PlayerTypes, bool, int&, int&, int&, int, bool);
	Func func;
	bool us;
	DealMod3(Func func, bool us) : func(func), us(us) {}
	virtual void modify(CvDeal* deal, DealModArgs& args)
	{
		(args.obj.*func)(deal, args.eThem, us ? args.bDontChangeMyExistingItems : args.bDontChangeTheirExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration, args.bUseEvenValue);
	}
};

struct DealMod4 : DealModBase
{
	typedef void (CvDealAI::*Func)(CvDeal*, PlayerTypes, bool, int&, int&, int&, bool);
	Func func;
	bool us;
	DealMod4(Func func, bool us) : func(func), us(us) {}
	virtual void modify(CvDeal* deal, DealModArgs& args)
	{
		(args.obj.*func)(deal, args.eThem, us ? args.bDontChangeMyExistingItems : args.bDontChangeTheirExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.bUseEvenValue);
	}
};

typedef std::vector<DealModBase*> ModList;

bool TryEqualize(ModList& mods, DealModArgs& args, DealModResult& result, CvDealAI& dealAI)
{	
	for (ModList::iterator it = mods.begin(); it != mods.end(); it++)
	{
		(*it)->modify(&result.deal, args);
	}

	
	
	dealAI.DoAddGPTToThem(&result.deal, args.eThem, args.bDontChangeTheirExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration, args.bUseEvenValue);
	dealAI.DoAddGPTToUs(&result.deal, args.eThem, args.bDontChangeMyExistingItems, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration, args.bUseEvenValue);


	if (!args.bDontChangeTheirExistingItems)
	{
		dealAI.DoRemoveGPTFromThem(&result.deal, args.eThem, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration, args.bUseEvenValue);
	}
	if (!args.bDontChangeMyExistingItems)
	{
		dealAI.DoRemoveGPTFromUs(&result.deal, args.eThem, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration, args.bUseEvenValue);
	}
	dealAI.DoRemoveGoldFromUs(&result.deal, args.eThem, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration);
	dealAI.DoRemoveGoldFromThem(&result.deal, args.eThem, args.iTotalValue, args.iValueImOffering, args.iValueTheyreOffering, args.iDealDuration);

	result.iValue = dealAI.GetDealValue(&result.deal, result.iValueToMe, result.iValueToThem, false, false);

	int iFinalValue = 0;
	int iFinalValueToMe = 0;
	int iFinalValueToThem = 0;
	int iFinalWillingMe = 0;
	int iFinalWillingThem = 0;

	bool bMakeOffer = dealAI.IsDealWithHumanAcceptable(&result.deal, args.eThem, iFinalValue, iFinalValueToMe, iFinalValueToThem, iFinalWillingMe, iFinalWillingThem, &result.bCantMatchOffer, false);
	if (result.bCantMatchOffer)
	{

		//dealAI.GetPlayer()->GetDiplomacyAI()->SetCantMatchDeal(args.eThem, true);
	}
	if (!result.deal.IsPeaceTreatyTrade(args.eThem))
	{
		//Getting 'error' values in this deal? It is bad, abort!
		if ((iFinalValueToThem == INT_MAX) || (iFinalValueToMe == INT_MAX) || (iFinalValue == INT_MAX))
		{
			
			return false;
		}
	}
	//Let's not lowball, it leads to spam.
	if (iFinalValueToMe > 0 && (iFinalValue > 0) && !result.bCantMatchOffer)
	{
		result.bAcceptable = true;
		return true;
	}
	result.bAcceptable = bMakeOffer;
	return bMakeOffer;
}

bool fairest_candidate_score_less_func(const DealModResult& a, const DealModResult& b)
{
	int va = abs(a.iValueToMe - a.iValueToThem);
	int vb = abs(b.iValueToMe - b.iValueToThem);
	if (va != vb)
		return va < vb;

	return a.iValue < b.iValue;
}

bool CvDealMaker::EqualizeDeal(CvDealAI& dealAI, CvDeal& deal, bool bDontChangeMyExistingItems, bool bDontChangeTheirExistingItems, bool& bDealGoodToBeginWith, bool& bCantMatchOffer)
{
	typedef std::vector<DealModBase*> ModList;
	ModList mods;
	mods.push_back(new DealMod1(&CvDealAI::DoAddCitiesToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyWarToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyPeaceToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddVoteCommitmentToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddVoteCommitmentToUs, true));
	mods.push_back(new DealMod1(&CvDealAI::DoAddEmbassyToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddEmbassyToUs, false));

	mods.push_back(new DealMod2(&CvDealAI::DoAddResourceToThem, false));
	mods.push_back(new DealMod2(&CvDealAI::DoAddResourceToUs, true));
	mods.push_back(new DealMod2(&CvDealAI::DoAddOpenBordersToThem, false));
	mods.push_back(new DealMod2(&CvDealAI::DoAddOpenBordersToUs, true));

	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyWarToThem, false));
	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyWarToUs, true));
	
	mods.push_back(new DealMod3(&CvDealAI::DoAddGPTToThem, false));
	mods.push_back(new DealMod3(&CvDealAI::DoAddGPTToUs, true));

	mods.push_back(new DealMod4(&CvDealAI::DoAddGoldToThem, false));
	mods.push_back(new DealMod4(&CvDealAI::DoAddGoldToUs, true));

	mods.push_back(new DealMod1(&CvDealAI::DoAddCitiesToUs, true));
	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyWarToUs, true));
	mods.push_back(new DealMod1(&CvDealAI::DoAddThirdPartyPeaceToUs, true));


	std::sort(mods.begin(), mods.end());

	PlayerTypes eThem = deal.GetOtherPlayer(dealAI.GetPlayer()->GetID());



	int iDealDuration = GC.getGame().GetDealDuration();
	
	bCantMatchOffer = true;

	if (deal.GetNumItems() <= 0)
	{
		return false;
	}

	dealAI.GetPlayer()->GetDiplomacyAI()->SetCantMatchDeal(eThem, true);

	// Is this a peace deal?
	/*
	normal eq func does this here but neglects to fill out teh already acceptable result
	if (deal.IsPeaceTreatyTrade(eThem))
	{
	deal.ClearItems();
	return dealAI.IsOfferPeace(eThem, &deal, true);
	}*/

	int iOrigValue = 0;
	int iOrigValueToMe = 0;
	int iOrigValueToThem = 0;
	int iWillingMe = 0;
	int iWillingThem = 0;

	bDealGoodToBeginWith = dealAI.IsDealWithHumanAcceptable(&deal, eThem, iOrigValue, iOrigValueToMe, iOrigValueToThem, iWillingMe, iWillingThem, &bCantMatchOffer, true);

	// Is this a peace deal?
	if (deal.IsPeaceTreatyTrade(eThem))
	{
		deal.ClearItems();
		return dealAI.IsOfferPeace(eThem, &deal, true);
	}
	

	typedef std::vector<DealModResult> DealModResults;
	DealModResults candidates;


	
	do
	{
		DealModArgs  args = {
			dealAI,

			eThem,
			bDontChangeTheirExistingItems,
			bDontChangeMyExistingItems,

			0,
			0,
			0,
			0,
			true,
			iDealDuration
		};
		DealModResult result = { deal, 0,0,0, true, false };

		TryEqualize(mods, args, result, dealAI);



		candidates.push_back(result);
	}
	while (std::next_permutation(mods.begin(), mods.end()));

	if (candidates.empty())
		return false;

	std::sort(candidates.begin(), candidates.end(), fairest_candidate_score_less_func);

	deal = candidates.front().deal;
	
	if(candidates.front().bCantMatchOffer)
		dealAI.GetPlayer()->GetDiplomacyAI()->SetCantMatchDeal(eThem, true);

	for (ModList::iterator it = mods.begin(); it != mods.end(); it++)
	{
		delete *it;
	}
	mods.clear();

	
	/*
		add all add/remove funcs to list
		for each permuation
			create copy of deal and apply all
			reject bad deals (...)
			score by abs((value_in_a/value_out_a)-(value_in_b/value_out_b)-1) if after fairness
			score by (value_in_a/value_out_a) if after best for us
			score by (value_in_a/value_out_a)-(value_in_b/value_out_b) if after disparity in our favour
			add to candidates
		sort candidates for "best" deal

		pick best!
		

		
	
	
	*/
	//------------------------
	// add all adders to vector
	// add all removers to vector

	// prune any invalid adders
	// prune any invalid removers

	//foreach valid adder
		// eval and store any that change in a vector
	//sort possible additions by ratio of value to me
	//pick highest or from top x% or range.

	//repeat until valued over

	// remove?

	//change golds...
}