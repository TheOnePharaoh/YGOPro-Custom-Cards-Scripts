--Vocaloid Rin Kagamine Mdl - Hz104
function c11111135.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111135,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c11111135.damcon)
	e2:SetTarget(c11111135.damtg)
	e2:SetOperation(c11111135.damop)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c11111135.con)
	e3:SetOperation(c11111135.op)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c11111135.atktg)
	e4:SetValue(c11111135.atkval)
	c:RegisterEffect(e4)
end
function c11111135.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c11111135.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c11111135.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c11111135.atktg(e,c)
	return c:IsRace(RACE_MACHINE)
end
function c11111135.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c11111135.atkval(e,c)
	return Duel.GetMatchingGroupCount(c11111135.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*200
end
function c11111135.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c11111135.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c11111135.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c11111135.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c11111135.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c11111135.penfilter2,tp,LOCATION_SZONE,0,nil)
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
