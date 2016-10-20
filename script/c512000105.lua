--Number 84: Pain Gainer
function c512000105.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2,c512000105.ovfilter,aux.Stringid(511000514,0),3,c512000105.xyzop)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c512000105.damop)
	c:RegisterEffect(e1)
	--gain atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000514,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCountLimit(1)
	e2:SetCondition(c512000105.atkcon)
	e2:SetCost(c512000105.atkcost)
	e2:SetOperation(c512000105.atkop)
	c:RegisterEffect(e2)
	if not c512000105.global_check then
		c512000105.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000105.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000105.xyz_number=84
function c512000105.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c512000105.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsSetCard(0x48) and c:GetCode()~=26556950
end
function c512000105.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c512000105.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c512000105.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c512000105.damop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
function c512000105.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c512000105.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000105.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ev)
		c:RegisterEffect(e1)
	end
end
function c512000105.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,26556950)
	Duel.CreateToken(1-tp,26556950)
end
