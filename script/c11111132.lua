--Vocaloid Kaai Yuki Mdl - Gl104
function c11111132.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111132,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111132.handescon)
	e2:SetTarget(c11111132.handestg)
	e2:SetOperation(c11111132.handesop)
	c:RegisterEffect(e2)
	--double
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c11111132.damcon)
	e3:SetOperation(c11111132.damop)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c11111132.con)
	e4:SetOperation(c11111132.op)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(11111132,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DICE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c11111132.destg)
	e5:SetOperation(c11111132.desop)
	c:RegisterEffect(e5)
	--atk
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c11111132.encfilter)
	e6:SetValue(500)
	c:RegisterEffect(e6)
end
function c11111132.handescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c11111132.handestg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c11111132.handesop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP) then
			Duel.Damage(1-tp,2000,REASON_EFFECT)
		end
	end
end
function c11111132.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c11111132.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c11111132.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c11111132.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c11111132.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c11111132.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c11111132.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c11111132.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c11111132.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,2)
end
function c11111132.dicefilter(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv and c:IsDestructable() and not c:IsType(TYPE_XYZ)
end
function c11111132.desop(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2=Duel.TossDice(tp,2)
	local sel=d1
	if d1>d2 then d1,d2=d2,d1 end
	if d1~=d2 then
		sel=Duel.AnnounceNumber(tp,d1,d2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c11111132.dicefilter,tp,0,LOCATION_MZONE,1,1,nil,sel)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c11111132.encfilter(e,c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_RITUAL)
end