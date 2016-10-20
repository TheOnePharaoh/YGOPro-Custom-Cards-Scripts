--Idol Master of Melody and Masacre Hikami Sumire
function c59821057.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,59821006),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c59821057.splimit)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-400)
	c:RegisterEffect(e2)
	--place pcard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821057,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c59821057.pencon)
	e3:SetTarget(c59821057.pentg)
	e3:SetOperation(c59821057.penop)
	c:RegisterEffect(e3)
	--must attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c59821057.effcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MUST_BE_ATTACKED)
	e5:SetCondition(c59821057.effcon)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_EP)
	e6:SetRange(LOCATION_PZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c59821057.atcon)
	c:RegisterEffect(e6)
	--atkdef up
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59821057,1))
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e7:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e7:SetCondition(c59821057.atkcon)
	e7:SetOperation(c59821057.atkop)
	c:RegisterEffect(e7)
	--immune
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(c59821057.efilter)
	c:RegisterEffect(e8)
	--skip main phase
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(59821057,2))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c59821057.skipcon)
	e9:SetOperation(c59821057.skipop)
	c:RegisterEffect(e9)
	--to pzone
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_DESTROYED)
	e10:SetCondition(c59821057.con)
	e10:SetOperation(c59821057.op)
	c:RegisterEffect(e10)
	--cannot mset
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_MSET)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_PZONE)
	e11:SetTargetRange(0,1)
	e11:SetTarget(aux.TRUE)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e12:SetTarget(c59821057.sumlimit)
	c:RegisterEffect(e12)
end
function c59821057.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
function c59821057.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c59821057.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821057.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821057.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821057.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821057.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821057.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821057.effcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0xa1a2)
end
function c59821057.atcon(e)
	return c59821057.effcon(e)
		and Duel.IsExistingMatchingCard(Card.IsAttackable,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c59821057.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c59821057.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(2500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c59821057.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821057.skipcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821057.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_M1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c59821057.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821057.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821057.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821057.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821057.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821057.penfilter2,tp,LOCATION_SZONE,0,nil)
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