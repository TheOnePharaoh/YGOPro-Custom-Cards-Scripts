--Twisted Vocaloid Type 0 Miku Hatsune
function c66652251.initial_effect(c)
	--fustion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x0dac405),2,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c66652251.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66652251,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c66652251.cost)
	e2:SetTarget(c66652251.target)
	e2:SetOperation(c66652251.operation)
	c:RegisterEffect(e2)
	--halve ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetCondition(c66652251.atkcon)
	e3:SetValue(c66652251.val)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66652251,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,66652251)
	e4:SetCondition(c66652251.thcon)
	e4:SetTarget(c66652251.thtg)
	e4:SetOperation(c66652251.thop)
	c:RegisterEffect(e4)
end
function c66652251.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652251.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x0dac405) and c:IsDiscardable()
end
function c66652251.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652251.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c66652230.thfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c66652251.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c66652251.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c66652251.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66652251.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c66652251.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c66652251.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c66652251.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()==nil
end
function c66652251.val(e,c)
	return c:GetAttack()/2
end
function c66652251.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652251.tgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(1000) and c:IsSetCard(0x0dac405) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c66652251.thfilter,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c66652251.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c66652251.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652251.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66652251.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66652251.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c66652251.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
