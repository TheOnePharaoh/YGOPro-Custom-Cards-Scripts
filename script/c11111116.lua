--Vocaloid Mayu Mdl - Hz101
function c11111116.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c11111116.atkval)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c11111116.con)
	e3:SetOperation(c11111116.op)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c11111116.encfilter)
	e4:SetValue(200)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11111116,1))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_PZONE)
	e5:SetTarget(c11111116.sgtg)
	e5:SetOperation(c11111116.sgop)
	c:RegisterEffect(e5)
end
function c11111116.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c11111116.atkval(e,c)
	return Duel.GetMatchingGroupCount(c11111116.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c)*300
end
function c11111116.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c11111116.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c11111116.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c11111116.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c11111116.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c11111116.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c11111116.encfilter(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c11111116.sgfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsAbleToGrave()
end
function c11111116.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c11111116.sgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c11111116.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11111116.sgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end