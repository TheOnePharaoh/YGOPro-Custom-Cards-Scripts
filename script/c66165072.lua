-- The Legendary Golem Mini Stone Giant
function c66165072.initial_effect(c)
	c:SetSPSummonOnce(66165072)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66165072,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c66165072.spcon)
	e1:SetTarget(c66165072.sptg)
	e1:SetOperation(c66165072.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--eff gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c66165072.effcon)
	e6:SetOperation(c66165072.effop)
	c:RegisterEffect(e6)
	--tohand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(66165072,1))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,66165072)
	e7:SetCondition(c66165072.thcon)
	e7:SetTarget(c66165072.thtg)
	e7:SetOperation(c66165072.thop)
	c:RegisterEffect(e7)
end
function c66165072.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c66165072.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c66165072.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,200,tp,tp,false,false,POS_FACEUP)
	end
end
function c66165072.effcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c66165072.effop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e1:SetValue(c66165072.tribvl)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c66165072.sumcon)
	e2:SetCost(c66165072.sumcost)
	e2:SetTarget(c66165072.sumtg)
	e2:SetOperation(c66165072.sumop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e2)
end
function c66165072.tribvl(e,c)
	return c:IsSetCard(0xea010)
end
function c66165072.sumlimit(e,c)
	return not c:IsSetCard(0xea010)
end
function c66165072.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SUMMON and c:GetReasonCard():IsSetCard(0xea010)
end
function c66165072.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xea010) and c:IsAbleToHand()
end
function c66165072.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c66165072.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66165072.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66165072.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c66165072.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c66165072.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c66165072.sumfilter(c)
	return c:IsSetCard(0xea010) and c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c66165072.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if (tn~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)))
		and Duel.IsExistingMatchingCard(c66165072.sumfilter,tp,LOCATION_HAND,0,1,nil) then
		e:SetLabel(1)
	end
end
function c66165072.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(18235309)==0
		and Duel.IsExistingMatchingCard(c66165072.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c66165072.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c66165072.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
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
