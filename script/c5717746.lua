--Under My Face - A Piece of Immortality
function c5717746.initial_effect(c)
	c:SetUniqueOnField(1,0,5717746)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c5717746.operation)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x0dac406)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(c5717746.reccon)
	e3:SetTarget(c5717746.rectg)
	e3:SetOperation(c5717746.recop)
	c:RegisterEffect(e3)
	--limit mod
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_HAND_LIMIT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetValue(100)
	e4:SetCondition(c5717746.handcon)
	c:RegisterEffect(e4)
end
function c5717746.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(3) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5717746.zfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelBelow(2) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c5717746.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c5717746.zfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5717746,0)) then Duel.SpecialSummonStep(g1:GetFirst(),0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
	local g2=Duel.SelectMatchingCard(tp,c5717746.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5717746,1)) then Duel.SpecialSummonStep(g2:GetFirst(),0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SpecialSummonComplete()
end
function c5717746.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x0dac406)
end
function c5717746.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c5717746.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c5717746.hadfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function c5717746.handcon(e)
	return Duel.IsExistingMatchingCard(c5717746.hadfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
