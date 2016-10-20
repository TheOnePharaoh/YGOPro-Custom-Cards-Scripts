--Ultimate Rainbow Kryos
function c8722170.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,8722152,8722153,8722154,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8722170,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(2,8722170)
	e3:SetCondition(c8722170.atcon)
	e3:SetCost(c8722170.atcost)
	e3:SetOperation(c8722170.atop)
	c:RegisterEffect(e3)
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCondition(c8722170.thcon)
	e4:SetTarget(c8722170.thtg)
	e4:SetOperation(c8722170.thop)
	c:RegisterEffect(e4)
end
function c8722170.costfilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c8722170.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		and Duel.GetAttacker()==c and c:IsChainAttackable(0)
end
function c8722170.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c8722170.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c8722170.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c8722170.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c8722170.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c8722170.thfilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c8722170.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8722170.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8722170.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8722170.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8722170.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
