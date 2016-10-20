--Vocaloid SeeU Mdl - Hz103
function c11111122.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111122,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111122.ctcon)
	e2:SetOperation(c11111122.ctop)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c11111122.con)
	e3:SetOperation(c11111122.op)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11111122,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c11111122.drcon)
	e4:SetTarget(c11111122.drtg)
	e4:SetOperation(c11111122.drop)
	c:RegisterEffect(e4)
	if not c11111122.global_check then
		c11111122.global_check=true
		c11111122[0]=0
		c11111122[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c11111122.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_MATERIAL_CHECK)
		ge2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge2:SetValue(c11111122.valcheck)
		ge2:SetLabelObject(ge1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c11111122.clearop)
		Duel.RegisterEffect(ge3,0)
	end
end
function c11111122.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c11111122.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c11111122.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c11111122.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local sg=g:GetMaxGroup(Card.GetAttack)
	if sg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		sg=sg:Select(tp,1,1,nil)
	end
	local tc=sg:GetFirst()
	if not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c11111122.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c11111122.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if bit.band(tc:GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
		local p=tc:GetSummonPlayer()
		c11111122[p]=c11111122[p]+e:GetLabel()
	end
end
function c11111122.valcheck(e,c)
	local ct=c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x0dac405)
	e:GetLabelObject():SetLabel(ct)
end
function c11111122.clearop(e,tp,eg,ep,ev,re,r,rp)
	c11111122[0]=0
	c11111122[1]=0
end
function c11111122.drcon(e,tp,eg,ep,ev,re,r,rp)
	return c11111122[tp]>0
end
function c11111122.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,c11111122[tp]) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,c11111122[tp])
end
function c11111122.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,c11111122[tp],REASON_EFFECT)
end
function c11111122.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c11111122.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c11111122.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c11111122.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c11111122.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c11111122.penfilter2,tp,LOCATION_SZONE,0,nil)
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