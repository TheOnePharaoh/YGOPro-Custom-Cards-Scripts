--Baha the Body, 3rd Arian Guardian
function c77790012.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77790012.spcost)
	e2:SetTarget(c77790012.sptg)
	e2:SetOperation(c77790012.spop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)	
	e3:SetCondition(c77790012.condition)
	e3:SetTarget(c77790012.tg)
	e3:SetOperation(c77790012.operation)
	c:RegisterEffect(e3)
	--ath
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c77790012.tg5)
	e4:SetOperation(c77790012.activate)
	c:RegisterEffect(e4)
end
function c77790012.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x100f) and c:GetLevel()>=10 and not c:IsCode(77790000) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c77790012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,5000) end
	Duel.PayLPCost(tp,5000)
end
function c77790012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77790012.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK)
end
function c77790012.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77790012.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end
function c77790012.vfilter(c)
	return c:IsFaceup() and (c:IsCode(77790008) or c:IsCode(77790009))
end
function c77790012.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c77790012.vfilter,c:GetControler(),LOCATION_SZONE,0,1,c)
end
function c77790012.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c77790012.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c77790012.selfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c77790012.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77790012.selfilter,tp,LOCATION_DECK,0,1,nil,77790000) 
		and Duel.IsExistingMatchingCard(c77790012.selfilter,tp,LOCATION_DECK,0,1,nil,77790001) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77790012.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c77790012.selfilter,tp,LOCATION_DECK,0,1,1,nil,77790000)
	local g2=Duel.SelectMatchingCard(tp,c77790012.selfilter,tp,LOCATION_DECK,0,1,1,nil,77790001)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end
