--Arcana Force V The Hierophant
function c123204.initial_effect(c)
	--select 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c123204.target)
	e1:SetOperation(c123204.operation)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123204,0))
	e2:SetCategory(CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c123204.cointg)
	e2:SetOperation(c123204.coinop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c123204.selfilter(c)
	return c:IsCode(73206827) and c:IsAbleToHand()
end
function c123204.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c123204.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c123204.selfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c123204.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123204.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123204.arcanareg(c,res)
end
function c123204.arcanareg(c,coin)
	c:RegisterFlagEffect(123204,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	if c:GetFlagEffectLabel(123204)==1 then
		e1:SetTarget(c123204.tg)
		e1:SetOperation(c123204.op)
	else
		e1:SetTarget(c123204.tg2)
		e1:SetOperation(c123204.op2)
	end
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c123204.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c123204.tg(e,tp,eg,ep,ev,re,r,rp,chk)
 	local c=e:GetHandler()	
	if chk==0 then return Duel.IsExistingMatchingCard(c123204.filter,tp,LOCATION_SZONE,0,1,c) end
	local sg=Duel.GetMatchingGroup(c123204.filter,tp,LOCATION_SZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c123204.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c123204.filter,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c123204.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c123204.filter,tp,0,LOCATION_SZONE,1,c) end
	local sg=Duel.GetMatchingGroup(c123204.filter,tp,0,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c123204.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c123204.filter,tp,0,LOCATION_SZONE,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end