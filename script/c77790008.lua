--Saneda the Space, 7th Arian Guardian
function c77790008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x100f),2,true)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--set to pzone before summoning
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c77790008.acon)
	e0:SetOperation(c77790008.aop)
	c:RegisterEffect(e0)
	--send replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77790008,1))
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c77790008.reptarget)
	e2:SetOperation(c77790008.repoperation)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c77790008.splimit)
	c:RegisterEffect(e3)
	--reflect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_REFLECT_DAMAGE)
	e4:SetValue(1)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--negate attack
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCondition(c77790008.condition3)
	e5:SetTarget(c77790008.target3)
	e5:SetOperation(c77790008.activate3)
	c:RegisterEffect(e5)
	--time-space network MZONE TO PZONE
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77790008,2))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c77790008.con2)
	e6:SetOperation(c77790008.op2)
	c:RegisterEffect(e6)
end
function c77790008.acon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c77790008.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c77790008.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77790008.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:GetDestination()==LOCATION_GRAVE or c:GetDestination()==LOCATION_EXTRA) and c:IsReason(REASON_DESTROY) end
	return Duel.SelectEffectYesNo(tp,c)
end
function c77790008.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)
end
function c77790008.condition3(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77790008.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local dam=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77790008.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackable() then
		if Duel.NegateAttack(tc) then
			Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)
		end
	end
end
function c77790008.con2(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable())
end
function c77790008.op2(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if Duel.Destroy(Group.FromCards(p1,p2),REASON_EFFECT)~=0 then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
