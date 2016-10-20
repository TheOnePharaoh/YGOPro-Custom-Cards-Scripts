--Mechquipped Bahamut
function c19007856.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19007856,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c19007856.drcon)
	e1:SetTarget(c19007856.drtg)
	e1:SetOperation(c19007856.drop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetTarget(c19007856.sumlimit)
	e2:SetCondition(c19007856.dscon)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19007856,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetCost(c19007856.atkcost)
	e3:SetTarget(c19007856.atktg)
	e3:SetOperation(c19007856.atkop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(19007856,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c19007856.spcon)
	e4:SetCost(c19007856.spcost)
	e4:SetTarget(c19007856.sptg)
	e4:SetOperation(c19007856.spop)
	c:RegisterEffect(e4)
end
function c19007856.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsFaceup() and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end
function c19007856.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19007856.cfilter,1,nil,tp)
end
function c19007856.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19007856.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c19007856.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c19007856.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsRankAbove(5)
end
function c19007856.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c19007856.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsCode(15914410) or c:IsCode(41309158)
end
function c19007856.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c19007856.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19007856,2))
	local g1=Duel.SelectTarget(tp,c19007856.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19007856,3))
	local g2=Duel.SelectTarget(tp,c19007856.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	e:SetLabelObject(g1:GetFirst())
end
function c19007856.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) then
		Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc1:GetAttack())
		tc2:RegisterEffect(e1)
	end
end
function c19007856.spcon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c19007856.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c19007856.spfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c19007856.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c19007856.spfilter2(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c19007856.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c19007856.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c19007856.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c19007856.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c19007856.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end