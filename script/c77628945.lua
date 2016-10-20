--Empowered Captain of the Black Art
function c77628945.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xba003),aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77628945.splimit)
	c:RegisterEffect(e1)
	--eff gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77628945.effcon)
	e2:SetOperation(c77628945.effop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77628945,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c77628945.thcon)
	e3:SetTarget(c77628945.thtg)
	e3:SetOperation(c77628945.thop)
	c:RegisterEffect(e3)
end
function c77628945.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77628945.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function c77628945.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--cannot chain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77628945,1))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetOperation(c77628945.chainop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77628945,2))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	e2:SetOperation(c77628945.tgtg)
	e2:SetValue(aux.tgoval)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2)
end
function c77628945.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0xba003) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c77628945.chainlm)
	end
end
function c77628945.chainlm(e,rp,tp)
	return tp==rp
end
function c77628945.tgtg(e,c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_FUSION)
end
function c77628945.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and ep~=tp
end
function c77628945.filter(c)
	return c:IsSetCard(0xba003) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77628945.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77628945.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77628945.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77628945.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end