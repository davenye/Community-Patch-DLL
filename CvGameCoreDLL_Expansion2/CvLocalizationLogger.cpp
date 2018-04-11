#include "CvGameCoreDLLPCH.h"
#include "CvLocalizationLogger.h"

namespace Localization
{

	CvLocalizationLogger::CvLocalizationLogger()
	{
	}


	CvLocalizationLogger::~CvLocalizationLogger()
	{
	}

	void CvLocalizationLogger::Log(const char * szMessage, LogTypes eType)
	{
		FILogFile* pLog = LOGFILEMGR.GetLog("Localization.log", 0);
		if (pLog)
		{
			static const char* logTypeString[3] = { "MSG", "WRN", "ERR" };
			pLog->Msg(CvString::format("%s: %s\r\n", logTypeString[eType], szMessage));
#if defined(STACKWALKER)// && defined(MOD_CORE_DEBUGGING)			
			//if (MOD_CORE_DEBUGGING)
			{
				pLog->Msg("Stack:\r\n");
				gStackWalker.SetLog(pLog);
				gStackWalker.ShowCallstack();
				pLog->Msg("\r\n");
			}
#endif
		}

	}

}