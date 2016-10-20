--Accel Vocaloid IA Mdl - Hz102
function c11111118.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111118,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111118.retcon)
	e2:SetTarget(c11111118.rettg)
	e2:SetOperation(c11111118.retop)
	c:RegisterEffect(e2)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c11111118.immunefilter)
	c:RegisterEffect(e2)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c11111118.con)
	e4:SetOperation(c11111118.op)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c11111118.encfilter)
	e5:SetValue(300)
	c:RegisterEffect(e5)
	--def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c11111118.encfilter)
	e6:SetValue(300)
	c:RegisterEffect(e6)
	--avoid battle damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_PZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(c11111118.encfilter)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c11111118.retcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c11111118.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c11111118.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c11111118.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c11111118.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c11111118.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c11111118.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c11111118.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c11111118.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c11111118.encfilter(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c11111118.immunefilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
