--Dramatic Ecounter
function c66165091.initial_effect(c)
	c:SetUniqueOnField(1,0,66165091)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c66165091.condition1)
	e1:SetCost(c66165091.cost1)
	e1:SetTarget(c66165091.target1)
	e1:SetOperation(c66165091.activate)
	c:RegisterEffect(e1)
	--instant
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66165091,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c66165091.condition2)
	e3:SetTarget(c66165091.target2)
	e3:SetOperation(c66165091.activate)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c66165091.sdcon)
	c:RegisterEffect(e4)
	--convert
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66165091,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c66165091.spcon)
	e5:SetTarget(c66165091.sptg)
	e5:SetOperation(c66165091.spop)
	c:RegisterEffect(e5)
end
function c66165091.confilter(c)
	return c:IsFaceup() and c:IsCode(66165070)
end
function c66165091.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c66165091.confilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66165091.filter(c)
	return c:IsSetCard(0xea010) and c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c66165091.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if (tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_BATTLE))
		and Duel.IsExistingMatchingCard(c66165091.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,94) then
		e:SetLabel(1)
	end
end
function c66165091.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()~=1 then return end
	e:GetHandler():RegisterFlagEffect(66165091,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c66165091.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c66165091.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function c66165091.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_BATTLE)
end
function c66165091.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(66165091)==0
		and Duel.IsExistingMatchingCard(c66165091.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c66165091.sdfilter(c)
	return c:IsFaceup() and c:IsCode(66165070)
end
function c66165091.sdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and not Duel.IsExistingMatchingCard(c66165091.sdfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c66165091.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_BATTLE) and re and re:GetOwner()~=c
end
function c66165091.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,66165091,0,0xea010,5,800,2400,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66165091.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,66165091,0,0xea010,5,800,2400,RACE_ROCK,ATTRIBUTE_EARTH) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end