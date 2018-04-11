#pragma once

#include "ILocalizationLogger.h"

namespace Localization
{
	// The existing logger provided a fairly low amount of information for fixing the issues.
	// This one can add a stack trace which will help in a few ways. Cheap and nasty but useful.
	class CvLocalizationLogger : public Localization::ILocalizationLogger
	{
	public:
		CvLocalizationLogger();
		virtual ~CvLocalizationLogger();

		virtual void Log(const char* szMessage, LogTypes eType = TYPE_MESSAGE);
	};

}