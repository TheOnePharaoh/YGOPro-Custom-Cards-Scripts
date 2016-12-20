--Witchcrafter Diana
function c77777717.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),5,3)
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
	e2:SetTarget(c77777717.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777717,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777717.sccon)
--	e3:SetTarget(c77777717.sctg)
	e3:SetOperation(c77777717.scop)
	c:RegisterEffect(e3)
	--pendulum set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetDescription(aux.Stringid(77777717,1))
	e4:SetCountLimit(1,77777717)
--	e4:SetCost(c77777717.cost)
	e4:SetTarget(c77777717.pentg)
	e4:SetOperation(c77777717.penop)
	c:RegisterEffect(e4)
	--Pendulum Place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77777717,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c77777717.pcon)
	e5:SetOperation(c77777717.pop)
	c:RegisterEffect(e5)
	--attack all
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ATTACK_ALL)
	e6:SetValue(c77777717.atkfilter)
	c:RegisterEffect(e6)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(77777717,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77777717.cost2)
	e1:SetTarget(c77777717.target)
	e1:SetOperation(c77777717.operation)
	c:RegisterEffect(e1)
end

c77777717.pendulum_level=5
function c77777717.atkfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c77777717.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777717.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777717.scop(e,tp,eg,ep,ev,re,r,rp)
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




function c77777717.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
end
function c77777717.pop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end



function c77777717.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.Destroy(tc,REASON_COST)
end
function c77777717.penfilter(c)
	return c:IsSetCard(0x407) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c77777717.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c77777717.penfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)end
	
end

function c77777717.penop(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local sg=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if Duel.Destroy(sg,REASON_COST)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c77777717.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end


function c77777717.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77777717.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsDefensePos() then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
	end
end
function c77777717.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.Damage(1-tp,500,REASON_EFFECT)~=0 and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end