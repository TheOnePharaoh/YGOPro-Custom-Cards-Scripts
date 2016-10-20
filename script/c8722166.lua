--Kryos Hunter
function c8722166.initial_effect(c)
	--fustion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xb1b32),2,true)
	c:EnableReviveLimit()
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c8722166.splimit)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c8722166.value)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8722166,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c8722166.thtg)
	e3:SetOperation(c8722166.thop)
	c:RegisterEffect(e3)
	--at limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c8722166.atlimit)
	c:RegisterEffect(e4)
end
function c8722166.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c8722166.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8722166.value(e,c)
	return Duel.GetMatchingGroupCount(c8722166.efilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c8722166.thfilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c8722166.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8722166.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8722166.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8722166.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8722166.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c8722166.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
