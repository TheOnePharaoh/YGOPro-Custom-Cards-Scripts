--Witchcrafter Yukiko
function c77777720.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x407),3,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777720.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777720,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777720.sccon)
--	e3:SetTarget(c77777720.sctg)
	e3:SetOperation(c77777720.scop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(77777720,1))
	e4:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c77777720.atktg1)
	e4:SetOperation(c77777720.atkop1)
	c:RegisterEffect(e4)
	--Pendulum Place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777720,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77777720.pcon)
	e5:SetOperation(c77777720.pop)
	c:RegisterEffect(e5)
	--negate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77777720,2))
	e6:SetCategory(CATEGORY_DISABLE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c77777720.discost)
	e6:SetTarget(c77777720.distg)
	e6:SetOperation(c77777720.disop)
	c:RegisterEffect(e6)
	--direct
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e7)
end

c77777720.pendulum_level=3
function c77777720.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777720.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777720.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end


function c77777720.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
end
function c77777720.pop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function c77777720.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x407)
end
function c77777720.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77777720.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777720.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77777720.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c77777720.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c77777720.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777720.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c77777720.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
	local atk=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,c)*400
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--cannot attack
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c77777720.antarget)
		e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function c77777720.antarget(e,c)
	return c~=e:GetHandler()
end