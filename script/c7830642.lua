--Dark Solenm Xyz Dragon
function c7830642.initial_effect(c)
	--xyz monster
	aux.AddXyzProcedure(c,nil,7,4)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7830642,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(c7830642.negcon)
	e1:SetCost(c7830642.negcost)
	e1:SetTarget(c7830642.negtg)
	e1:SetOperation(c7830642.negop)
	c:RegisterEffect(e1)
	--special summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7830642,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c7830642.sscondition)
	e2:SetTarget(c7830642.sstarget)
	e2:SetOperation(c7830642.ssoperation)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7830642,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c7830642.atkcon)
	e3:SetCost(c7830642.cost)
	e3:SetTarget(c7830642.atktg)
	e3:SetOperation(c7830642.atkop)
	c:RegisterEffect(e3)
end
function c7830642.sscondition(e,tp,ev,eg,ep,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and (e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16195942) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,1621413))
end
function c7830642.ssfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c7830642.sstarget(e,tp,ev,eg,ep,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c7830642.ssoperation(e,tp,ev,eg,ep,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	if Duel.IsExistingTarget(c7830642.ssfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(7830642,1)) then
	local g=Duel.SelectTarget(tp,c7830642.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g then
		Duel.SpecialSummon(g,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP)
	end
	end
end
function c7830642.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and Duel.IsChainDisablable(ev) and (e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16195942) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,1621413))
end
function c7830642.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c7830642.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetChainLimit(c7830642.chlimit)
end
function c7830642.chlimit(e,ep,tp)
	return tp==ep
end
function c7830642.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c7830642.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c7830642.actlimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c7830642.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,16195942) or e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,1621413)
end
function c7830642.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7830642.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.nzatk(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tg=Duel.SelectTarget(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tg,tg:GetCount(),0,0)
end
function c7830642.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local atk=tc:GetBaseAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				c:RegisterEffect(e2)
		   end
		end
		tc=tg:GetNext()
   end
end