--Gigas of the Arch Beetle
function c78330029.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78330029,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c78330029.sptg)
	e2:SetOperation(c78330029.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c78330029.spcon)
	e3:SetOperation(c78330029.spop2)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(78330029,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCondition(c78330029.condition)
	e4:SetTarget(c78330029.target)
	e4:SetOperation(c78330029.operation)
	c:RegisterEffect(e4)
end
function c78330029.costfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xac9812) and not c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and c:GetLevel()>0
		and Duel.IsExistingTarget(c78330029.spfilter,tp,LOCATION_DECK,0,1,c,e,tp,c:GetLevel())
end
function c78330029.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xac9812) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c78330029.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c78330029.spfilter(chkc,e,tp,e:GetLabel()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78330029.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78330029.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c78330029.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c78330029.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c78330029.spfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xac9812) and not c:IsCode(78330029) and c:IsAbleToRemoveAsCost()
end
function c78330029.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c78330029.spfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c78330029.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78330029.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c78330029.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c78330029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200)
end
function c78330029.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
