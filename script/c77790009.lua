--Bhunivelze the Time, 6th Arian Guardian
function c77790009.initial_effect(c)
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
	e0:SetCondition(c77790009.acon)
	e0:SetOperation(c77790009.aop)
	c:RegisterEffect(e0)
	--time manipulate/reset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77790009,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c77790009.target)
	e2:SetOperation(c77790009.operation)
	c:RegisterEffect(e2)
	--future vision
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetValue(2)
	c:RegisterEffect(e3)
	--back to past
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c77790009.bdcon)
	e4:SetTarget(c77790009.bdtg)
	e4:SetOperation(c77790009.bdop)
	c:RegisterEffect(e4)
	--spsummon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	e5:SetValue(c77790009.splimit)
	c:RegisterEffect(e5)
	--Causality
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(c77790009.atkcon)
	e6:SetOperation(c77790009.atkop)
	c:RegisterEffect(e6)
	--time loop
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EXTRA_ATTACK)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--time-space network MZONE TO PZONE
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(77790009,1))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c77790009.con2)
	e8:SetOperation(c77790009.op2)
	c:RegisterEffect(e8)
end
function c77790009.acon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.GetFieldCard(tp,LOCATION_SZONE,6) and not Duel.GetFieldCard(tp,LOCATION_SZONE,7)
end
function c77790009.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c77790009.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77790009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,2)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,e:GetHandler())end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,2)
end
function c77790009.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(1-p,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,2,REASON_EFFECT)
end
function c77790009.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()<=10 and c:IsSetCard(0x100f)
end
function c77790009.bdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_SZONE  and e:GetHandler():IsReason(REASON_DESTROY)
end
function c77790009.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0x1e,0x1e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c77790009.bdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0x1e,0x1e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
	Duel.BreakEffect()
end
function c77790009.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function c77790009.atkop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	Duel.Damage(1-tp,bc:GetAttack(),REASON_EFFECT)
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
