----D.S. Sea Xianlong
function c29001791.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsRace,RACE_FISH),1)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c29001791.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29001791,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.bdogcon)
	e2:SetTarget(c29001791.sptg)
	e2:SetOperation(c29001791.spop)
	c:RegisterEffect(e2)
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c29001791.limcon)
	e3:SetOperation(c29001791.limop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_END)
	e5:SetOperation(c29001791.limop2)
	c:RegisterEffect(e5)
	--nontuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_NONTUNER)
	e6:SetCondition(c29001791.limcon)
	c:RegisterEffect(e6)
end
function c29001791.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c29001791.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c29001791.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end
	end
end
function c29001791.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c29001791.limcon(e)
	return Duel.IsExistingMatchingCard(c29001791.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c29001791.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c29001791.chainlm)
	else
		e:GetHandler():RegisterFlagEffect(29001791,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c29001791.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetOverlayCount()>0 and e:GetHandler():GetFlagEffect(29001791)~=0 then
		Duel.SetChainLimitTillChainEnd(c29001791.chainlm)
	end
	e:GetHandler():ResetFlagEffect(29001791)
end
function c29001791.chainlm(e,rp,tp)
	return tp==rp
end
