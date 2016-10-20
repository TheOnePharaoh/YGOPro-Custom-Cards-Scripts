--The Idol Master of Time and Space Sumire Hikami
function c59821050.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa1a2),aux.NonTuner(Card.IsSetCard,0xa1a2),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa1a2))
	c:RegisterEffect(e2)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xa1a2))
	c:RegisterEffect(e3)
	--immune effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c59821050.immfilter)
	c:RegisterEffect(e4)
	--atk down
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(-400)
	c:RegisterEffect(e5)
	--place pcard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821050,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1,59821050)
	e6:SetCondition(c59821050.pencon)
	e6:SetTarget(c59821050.pentg)
	e6:SetOperation(c59821050.penop)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c59821050.atkval)
	c:RegisterEffect(e7)
	--special summon
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821050,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCondition(c59821050.spcon)
	e8:SetCost(c59821050.spcost)
	e8:SetTarget(c59821050.sptg)
	e8:SetOperation(c59821050.spop)
	c:RegisterEffect(e8)
	--to pzone
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetCondition(c59821050.con)
	e9:SetOperation(c59821050.op)
	c:RegisterEffect(e9)
end
function c59821050.immfilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c59821050.penfilter4(c)
    return c:IsSetCard(0xa1a2) or c:IsCode(59821039) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049)
end
function c59821050.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821050.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821050.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821050.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821050.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)*200
end
function c59821050.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c59821050.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c59821050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c59821050.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c59821050.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821050.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821050.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821050.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821050.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821050.penfilter2,tp,LOCATION_SZONE,0,nil)
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