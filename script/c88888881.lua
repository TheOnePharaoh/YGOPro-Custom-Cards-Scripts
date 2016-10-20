--Vocaloid Sekka Yuffu
function c88888881.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888881,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c88888881.drcon)
	e1:SetTarget(c88888881.drtarg)
	e1:SetOperation(c88888881.drop)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e2)
	--battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c88888881.con)
	e4:SetOperation(c88888881.op)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c88888881.spcon)
	c:RegisterEffect(e5)
end
function c88888881.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c88888881.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c88888881.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c88888881.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c88888881.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c88888881.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c88888881.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c88888881.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c88888881.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c88888881.spfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetCode()~=88888881
end
function c88888881.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c88888881.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88888881.valfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c88888881.valcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c88888881.valfilter,c:GetControler(),LOCATION_MZONE,0,2,c)
end
