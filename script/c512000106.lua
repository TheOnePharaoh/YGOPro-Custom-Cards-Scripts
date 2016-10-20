--Number 35: Ravenous Tarantula
function c512000106.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2)
	c:EnableReviveLimit()
	--half atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c512000106.atktg)
	e1:SetValue(c512000106.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511000516,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c512000106.efcost)
	e3:SetTarget(c512000106.eftg)
	e3:SetOperation(c512000106.efop)
	c:RegisterEffect(e3)
	if not c512000106.global_check then
		c512000106.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c512000106.numchk)
		Duel.RegisterEffect(ge2,0)
	end
end
c512000106.xyz_number=35
function c512000106.atktg(e,c)
	return c:IsRace(RACE_INSECT)
end
function c512000106.val(e,c)
	local tp=e:GetHandler():GetControler()
	if Duel.GetLP(tp)<=Duel.GetLP(1-tp) then
		return Duel.GetLP(1-tp)-Duel.GetLP(tp)
	else
		return Duel.GetLP(tp)-Duel.GetLP(1-tp)
	end
end
function c512000106.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c512000106.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=Duel.SelectOption(tp,aux.Stringid(511000516,1),aux.Stringid(511000516,2))
	e:SetLabel(op)
end
function c512000106.efop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Recover(tp,2000,REASON_EFFECT)
	else
		local lp1=Duel.GetLP(tp)
		local lp2=Duel.GetLP(1-tp)
		Duel.SetLP(tp,lp2)
		Duel.SetLP(1-tp,lp1)
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end
function c512000106.numchk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,90162951)
	Duel.CreateToken(1-tp,90162951)
end
