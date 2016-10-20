--Bacteria Contamination - Song of the Haunting Nightmare
function c77662921.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	--remove overlay replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77662921,0))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c77662921.rcon)
	e3:SetOperation(c77662921.rop)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c77662921.discon)
	e4:SetOperation(c77662921.disop)
	c:RegisterEffect(e4)
end
function c77662921.rcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetFlagEffect(77662921+ep)==0
		and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():GetOverlayCount()>=ev-1
		and Duel.CheckLPCost(rp,1000)
end
function c77662921.rop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=bit.band(ev,0xffff)
	Duel.PayLPCost(rp,1000,REASON_EFFECT)
	if ct>1 then
		re:GetHandler():RemoveOverlayCard(tp,ct-1,ct-1,REASON_COST)
	end
	e:GetHandler():RegisterFlagEffect(77662921+ep,RESET_PHASE+PHASE_END,0,1)
end
function c77662921.discon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local code=a:GetCode()
	local at=Duel.GetAttackTarget()
	return at and (code==90127555 or code==90127556 or code==98999271 or code==59306850 or code==16722939 or code==98999272 or code==77662926 or code==77662927)
end
function c77662921.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e2)
end