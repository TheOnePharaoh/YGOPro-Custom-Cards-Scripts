--Black Kryos
function c8722158.initial_effect(c)
	--fustion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xb1b32),3,true)
	c:EnableReviveLimit()
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c8722158.splimit)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c8722158.econdition)
	e2:SetTarget(c8722158.etarget)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8722157,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c8722157.thtg)
	e3:SetOperation(c8722157.thop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c8722157.atkvalue)
	c:RegisterEffect(e4)
end
function c8722158.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c8722158.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8722158.econdition(e)
	return Duel.IsExistingMatchingCard(c8722158.efilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c8722158.etarget(e,c)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(8722158)
end
function c8722158.thfilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c8722158.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8722158.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8722158.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8722158.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8722158.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c8722158.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8722158.atkvalue(e,c)
	return Duel.GetMatchingGroupCount(c8722158.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)*200
end