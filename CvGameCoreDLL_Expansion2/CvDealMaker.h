#pragma once

class CvDeal;
class CvDealAI;

class CvDealMaker
{
public:
	CvDealMaker();
	virtual ~CvDealMaker();

	enum ChangeFlags {
		nah = 0, yeah = 1
	};
	bool EqualizeDeal(CvDealAI& dealAI, CvDeal& deal, bool bDontChangeMyExistingItems, bool bDontChangeTheirExistingItems, bool& bDealGoodToBeginWith, bool& bCantMatchOffer);
};

